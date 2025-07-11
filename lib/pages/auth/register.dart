part of 'auth.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(userNotifierProvider);
    final notifier = ref.read(userNotifierProvider.notifier);

    final size = MediaQuery.of(context).size;

    void _handleRegister() async {
      if(state.isLoading) return;
        final password = _passwordController1.text;
        final confirmPassword = _passwordController2.text;

        if (password != confirmPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password dan konfirmasi password tidak sama."),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        await notifier.register(
          _usernameController.text,
          _emailController.text.trim(),
          password
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
    };

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.1),
                MyTextField(
                  controller: _emailController,
                  name: "Email",
                  prefixIcon: Icons.email,
                  inputType: TextInputType.emailAddress,
                  hintText: "ilham@gmail.com",
                ),
                SizedBox(height: size.height * 0.02),
                MyTextField(
                  controller: _usernameController,
                  name: "Username",
                  prefixIcon: Icons.person,
                  inputType: TextInputType.name,
                  hintText: "ilhamgod14",
                  obscureText: false,
                ),
                SizedBox(height: size.height * 0.02),
                MyTextField(
                  controller: _passwordController1,
                  name: "Password",
                  prefixIcon: Icons.password,
                  inputType: TextInputType.visiblePassword,
                  hintText: "",
                  obscureText: true,
                ),
                SizedBox(height: size.height * 0.02),
                MyTextField(
                  controller: _passwordController2,
                  name: "Confirm Password",
                  prefixIcon: Icons.password,
                  inputType: TextInputType.visiblePassword,
                  hintText: "",
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: size.width * 0.035,
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
                        },
                        child: Text(
                          "Masuk",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: size.width * 0.038,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: Text(
                        "ATAU",
                        style: TextStyle(fontSize: size.width * 0.035),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Image.asset(
                          "assets/images/google.png",
                          width: size.width * 0.12
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    GestureDetector(
                      child: Image.asset(
                        "assets/images/facebook.png",
                        width: size.width * 0.12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.1),
                Column(
                  children: [
                    GestureDetector(
                      onTap: _handleRegister,
                      child: Container(
                        width: size.width * 0.4,
                        height: size.height * 0.06,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.015,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: state.isLoading ? Colors.grey : Theme.of(context).colorScheme.secondary,
                        ),
                        child: Center(
                          child: state.isLoading
                              ? CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          )
                              : Text(
                            "Daftar",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
