import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/auth_provider.dart';
import 'verify_otp_screen.dart';
import '../../../services/two_factor_service.dart';
import '../../../main.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _cityController = TextEditingController();
  final _landmarkController = TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _selectedDept;
  String? _selectedSemester;
  final List<String> _departments = ['???', '????', 'ICT', '????'];

  final Map<int, String> _semesterMap = {
    1: "????? ?????",
    2: "????? ??????",
    3: "????? ??????",
    4: "????? ??????",
    5: "????? ??????",
    6: "????? ??????",
    7: "????? ??????",
    8: "????? ??????",
  };

  void _generateStrongPassword() {
    const String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lower = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*(),.?":{}|<>';
    const String allChars = upper + lower + numbers + symbols;

    Random random = Random();
    String password = upper[random.nextInt(upper.length)];
    password += lower[random.nextInt(lower.length)];
    password += numbers[random.nextInt(numbers.length)];
    password += symbols[random.nextInt(symbols.length)];

    for (int i = 0; i < 8; i++) {
      password += allChars[random.nextInt(allChars.length)];
    }

    List<String> passwordList = password.split('')..shuffle();
    String finalPassword = passwordList.join();

    setState(() {
      _passwordController.text = finalPassword;
      _confirmPasswordController.text = finalPassword;
      _passwordVisible = true;
      _confirmPasswordVisible = true;
    });

    _showScreenshotWarning();
  }

  void _showScreenshotWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "?? ?? ????? ???? ???? ????.. ?? ???? ???? ??? ??? ?? ???? ???!",
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
        duration: Duration(seconds: 5),
      ),
    );
  }

  void _copyToClipboard() {
    if (_passwordController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _passwordController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("?? ??? ???? ??????"), backgroundColor: Colors.green),
      );
    }
  }

  List<String> _getSemesters() {
    List<int> numbers = [];
    if (_selectedDept == '???') {
      numbers = [1, 2];
    } else if (_selectedDept != null) {
      numbers = [3, 4, 5, 6, 7, 8];
    }
    return numbers.map((n) => _semesterMap[n]!).toList();
  }

  bool _isPasswordStrong(String password) {
    if (password.length < 8) return false;
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isPasswordStrong(_passwordController.text)) {
      _showError(
          "???? ???? ?????! ??? ?? ????? ??? ???? ????? ?????? ?????? ????? ?????? 8 ????? ??? ?????");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError("????? ???? ??? ?????????");
      return;
    }

    if (_selectedDept == null || _selectedSemester == null) {
      _showError("?????? ?????? ????? ?????? ???????");
      return;
    }

    setState(() => _isLoading = true);

    // TODO: RE-ENABLE OTP � Change kOtpEnabled to true to restore phone verification
    const bool kOtpEnabled = false;

    // Use a variable explicitly to avoid constant false dead code path during analysis
    if (kOtpEnabled == true) {
      // ---- Original OTP flow (preserved for re-enablement) ----
      try {
        final phoneService = TwoFactorService();
        final formattedPhone =
            phoneService.formatLibyanNumber(_phoneController.text.trim());

        await phoneService.requestOTP(
          phoneNumber: formattedPhone,
          onCodeSent: (verificationId, resendToken) {
            if (mounted) {
              setState(() => _isLoading = false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerifyOTPScreen(
                    verificationId: verificationId,
                    phoneNumber: formattedPhone,
                    onVerify: (otp) =>
                        _completeRegistration(otp, verificationId),
                  ),
                ),
              );
            }
          },
          onVerificationFailed: (e) {
            if (mounted) {
              setState(() => _isLoading = false);
              _showError("??? ????? ?????: ${e.message}");
            }
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showError("??? ??? ??? ?????");
        }
      }
    } else {
      // ---- Bypass: Register directly with email/password (OTP disabled) ----
      await _completeRegistrationDirect();
    }
  }

  /// Used when OTP is enabled � verifies phone then creates account
  Future<void> _completeRegistration(String otp, String verificationId) async {
    try {
      // For now, OTP flow is disabled. Refactoring specific Firebase PhoneAuth 
      // is deferred until OTP is re-enabled but we will just emit a message.
      _showError("OTP verification is currently unsupported in this architecture.");
      setState(() => _isLoading = false);
    } catch (e) {
      _showError("??? ??????: $e");
      setState(() => _isLoading = false);
    }
  }

  /// Used when OTP is disabled � registers directly with email/password
  /// TODO: RE-ENABLE OTP � Remove this method when kOtpEnabled = true
  Future<void> _completeRegistrationDirect() async {
    try {
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        setState(() => _isLoading = false);
        _showError("?????? ?????????? ????? ??????? ???? OTP");
        return;
      }

      final userData = {
        'fullName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'personalEmail': email,
        'nationalId': _nationalIdController.text.trim(),
        'studentID': '',
        'departmentName': _selectedDept,
        'semester': _selectedSemester,
        'city': _cityController.text.trim(),
        'landmark': _landmarkController.text.trim(),
        'role': 'student',
        'twoFactorEnabled': false,
      };

      await ref.read(authProvider.notifier).register(
            email,
            _passwordController.text,
            userData,
          );

      if (!mounted) return;
      
      final authState = ref.read(authProvider);
      if (authState.hasError) {
        setState(() => _isLoading = false);
        _showError("??? ????? ??????: ${authState.error}");
        return;
      }

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('?? ????? ?????? ?????!')));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
          (route) => false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError("??? ????? ??????: $e");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, textAlign: TextAlign.right),
          backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF203A43),
                    Color(0xFF2C5364)
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("????? ???? ???????",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 10),
                    const Text("???? ??????? ???? ???????? ??????",
                        style: TextStyle(color: Colors.white60)),
                    const SizedBox(height: 40),
                    _buildField(_nameController, "????? ??????? *",
                        Icons.person_outline),
                    _buildField(
                        _phoneController, "9XXXXXXXX", Icons.phone_android,
                        isNumber: true, label: "??? ?????? ???? 0 *"),
                    _buildField(_emailController, "?????? ?????? (???????)",
                        Icons.email_outlined,
                        required: false),
                    _buildField(_nationalIdController, "????? ?????? *",
                        Icons.badge_outlined,
                        isNumber: true),
                    _buildField(_cityController, "??????? *",
                        Icons.location_city_outlined),
                    _buildField(_landmarkController, "???? ???? ???? *",
                        Icons.location_on_outlined),
                    const SizedBox(height: 10),
                    _buildGlassDropdown(
                        hint: "???? ????? *",
                        value: _selectedDept,
                        items: _departments,
                        onChanged: (v) => setState(() {
                              _selectedDept = v;
                              _selectedSemester = null;
                            })),
                    const SizedBox(height: 20),
                    _buildSemesterDropdown(
                        hint: "???? ????? ??????? *",
                        value: _selectedSemester,
                        items: _getSemesters(),
                        onChanged: (v) =>
                            setState(() => _selectedSemester = v)),
                    const SizedBox(height: 20),
                    _buildField(
                        _passwordController, "???? ???? *", Icons.lock_outline,
                        isPass: true,
                        isVisible: _passwordVisible,
                        onVisibilityToggle: () => setState(
                            () => _passwordVisible = !_passwordVisible),
                        extraSuffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.bolt, color: Colors.amber),
                              onPressed: _generateStrongPassword,
                              tooltip: "????? ???? ???? ????",
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy,
                                  color: Colors.white70, size: 20),
                              onPressed: _copyToClipboard,
                              tooltip: "???",
                            ),
                          ],
                        )),
                    _buildField(_confirmPasswordController, "????? ???? ???? *",
                        Icons.lock_reset,
                        isPass: true,
                        isVisible: _confirmPasswordVisible,
                        onVisibilityToggle: () => setState(() =>
                            _confirmPasswordVisible =
                                !_confirmPasswordVisible)),
                    const SizedBox(height: 30),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("????? ??????",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
      ),
    );
  }

  Widget _buildField(
      TextEditingController controller, String hint, IconData icon,
      {bool isPass = false,
      bool isNumber = false,
      bool required = true,
      bool? isVisible,
      VoidCallback? onVisibilityToggle,
      String? label,
      Widget? extraSuffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: controller,
          obscureText: isPass && (isVisible == null || !isVisible),
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label ?? hint,
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: Icon(icon, color: Colors.white70),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (extraSuffix != null) extraSuffix,
                if (isPass)
                  IconButton(
                      icon: Icon(
                          isVisible == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70),
                      onPressed: onVisibilityToggle),
              ],
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
          ),
          validator: required
              ? (v) => v == null || v.isEmpty ? "??? ????? ?????" : null
              : null,
        ),
      ),
    );
  }

  Widget _buildGlassDropdown(
      {required String hint,
      String? value,
      required List<String> items,
      required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
          dropdownColor: const Color(0xFF1E293B),
          items: items
              .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(color: Colors.white))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSemesterDropdown(
      {required String hint,
      String? value,
      required List<String> items,
      required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
          dropdownColor: const Color(0xFF1E293B),
          items: items
              .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(color: Colors.white))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nationalIdController.dispose();
    _cityController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }
}
