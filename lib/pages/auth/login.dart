part of 'auth.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(userNotifierProvider);
    final notifier = ref.read(userNotifierProvider.notifier);

    final size = MediaQuery.of(context).size;

    void _handleLogin() async {
      if(state.isLoading) return;

      await notifier.login(
        _emailController.text.trim(),
        _passwordController.text,
        ref,
      );

      if (ref.read(userNotifierProvider).error != null) {
        print("Ada yang salah nih woiii: ${ref.read(userNotifierProvider).error}");
        return;
      } else {
        print("Login successful! Navigating to Home");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
      }
    }

    return Scaffold(
      body:Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02,
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
                  controller: _passwordController,
                  name: "Password",
                  prefixIcon: Icons.password,
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Belum Punya akun?",
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
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Register()));
                        },
                        child: Text(
                          "Daftar",
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
                      onTap: _handleLogin,
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
                            "Masuk",
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
