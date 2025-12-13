import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:routiner/feature/auth/presentation/widgets/custom_sign_in_bottom_nav.dart';
import 'package:routiner/feature/auth/presentation/widgets/forgot_password_button.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_label_text.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_text_field.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.onLoggedIn});

  final Future<void> Function({bool isFromSignup})? onLoggedIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => BlocProvider(
    create: (final BuildContext context) => AppInjector.getIt<LoginBloc>(),
    child: BlocListener<LoginBloc, LoginState>(
      listener: (final BuildContext context, final LoginState state) async {
        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.locale.loginSuccess)),
          );

          // Call the callback to trigger AuthGuard's resolver.next()
          // This callback was passed from AuthGuard
          if (widget.onLoggedIn != null) {
            await widget.onLoggedIn!(isFromSignup: false);
            // After resolver.next() is called in AuthGuard,
            // navigation will automatically proceed to the guarded route
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.appColors.cF6F9FF,
        appBar: CustomAppBar(
          title: context.locale.continueWithEmail,
        ),
        bottomNavigationBar: BlocBuilder<LoginBloc, LoginState>(
          builder: (final BuildContext context, final LoginState state) {
            final bool isLoading = state is LoginLoading;
            return CustomSignInBottomNav(
              onCreateAccountPressed: () {
                context.router.push( SignUpRoute(onLoggedIn: widget.onLoggedIn));
              },
              onNextPressed: () {
                context.read<LoginBloc>().add(
                  ValidateAndLogin(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
              },
              nextEnabled: !isLoading,
            );
          },
        ),
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (final BuildContext context, final LoginState state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final bool showEmailError =
                state is LoginUser && !state.emailValid;
            final bool showPasswordError =
                state is LoginUser && !state.passwordValid;

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              children: [
                FormLabelText(context.locale.email),
                FormTextField(
                  controller: emailController,
                  onChanged: (final String value) {
                    context.read<LoginBloc>().add(
                      EmailChanged(email: value),
                    );
                  },
                  hintText: context.locale.enterEmail,
                  errorText: showEmailError
                      ? context.locale.emailEmptyError
                      : null,
                ),
                const SizedBox(height: 20),
                FormLabelText(context.locale.password),
                FormTextField(
                  controller: passwordController,
                  onChanged: (final String value) {
                    context.read<LoginBloc>().add(
                      PasswordChanged(password: value),
                    );
                  },
                  hintText: context.locale.enterPassword,
                  obscureText: true,
                  errorText: showPasswordError
                      ? context.locale.passwordEmptyError
                      : null,
                ),
                const SizedBox(height: 10),
                ForgotPassword(
                  onPressed: () {
                    // Navigate to forgot password screen
                    // context.router.push(ForgotPasswordRoute());
                  },
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}