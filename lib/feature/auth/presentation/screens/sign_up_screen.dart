import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/utils/date_input_formatter.dart';
import 'package:routiner/feature/auth/presentation/bloc/signup_bloc/signup_bloc.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_label_text.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_text_field.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/next_button.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.onLoggedIn});

  final Future<void> Function({bool isFromSignup})? onLoggedIn;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    birthdateController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => BlocProvider<SignupBloc>(
    create: (final BuildContext context) => AppInjector.getIt<SignupBloc>(),
    child: Scaffold(
      backgroundColor: context.appColors.cF6F9FF,
      appBar: CustomAppBar(title: context.locale.createAccount),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: BlocSelector<SignupBloc, SignupState, bool>(
          selector: (final SignupState state) {
            if (state is SignupUser) {
              return state.name.isNotEmpty &&
                  state.surname.isNotEmpty &&
                  state.birthdate.isNotEmpty &&
                  state.email.isNotEmpty &&
                  state.password.isNotEmpty;
            }
            return false;
          },
          builder: (final BuildContext context, final bool isFormValid) {
            return NextButton(
              enabled: isFormValid,
              onPressed: () {
                context.read<SignupBloc>().add(
                  ValidateAndSignup(
                    name: nameController.text,
                    surname: surnameController.text,
                    birthdate: birthdateController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                );
              },
            );
          },
        ),
      ),
      body: BlocListener<SignupBloc, SignupState>(
        listener: (final BuildContext context, final SignupState state) async {
          if (state is SignupError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.locale.loginSuccess)),
            );

            // Call the callback to trigger AuthGuard's flow
            // AuthGuard will navigate to CreateProfileRoute
            // and pass resolver.next as onProfileCompleted callback
            if (widget.onLoggedIn != null) {
              await widget.onLoggedIn!(isFromSignup: true);
              // After this, AuthGuard handles navigation to CreateProfileRoute
            }
          }
        },
        child:
        BlocSelector<
            SignupBloc,
            SignupState,
            ({
            bool isLoading,
            bool showNameError,
            bool showSurnameError,
            bool showBirthdateError,
            bool showEmailError,
            bool showPasswordError,
            String name,
            String surname,
            String birthdate,
            String email,
            String password,
            })
        >(
          selector: (final SignupState state) => (
          isLoading: state is SignupLoading,
          showNameError: state is SignupUser && !state.nameValid,
          showSurnameError: state is SignupUser && !state.surnameValid,
          showBirthdateError:
          state is SignupUser && !state.birthdateValid,
          showEmailError: state is SignupUser && !state.emailValid,
          showPasswordError: state is SignupUser && !state.passwordValid,
          name: state is SignupUser ? state.name : '',
          surname: state is SignupUser ? state.surname : '',
          birthdate: state is SignupUser ? state.birthdate : '',
          email: state is SignupUser ? state.email : '',
          password: state is SignupUser ? state.password : '',
          ),
          builder:
              (
              final BuildContext context,
              final ({
              String name,
              String surname,
              String birthdate,
              String email,
              String password,
              bool isLoading,
              bool showNameError,
              bool showSurnameError,
              bool showBirthdateError,
              bool showEmailError,
              bool showPasswordError,
              })
              data,
              ) {
            if (data.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              children: <Widget>[
                FormLabelText(context.locale.name),
                const SizedBox(height: 8),
                FormTextField(
                  controller: nameController,
                  onChanged: (final String value) {
                    context.read<SignupBloc>().add(
                      NameChanged(name: value),
                    );
                  },
                  hintText: context.locale.enterName,
                  errorText: data.showNameError
                      ? context.locale.nameEmptyError
                      : null,
                ),
                const SizedBox(height: 20),
                FormLabelText(context.locale.surname),
                const SizedBox(height: 8),
                FormTextField(
                  controller: surnameController,
                  onChanged: (final String value) {
                    context.read<SignupBloc>().add(
                      SurnameChanged(surname: value),
                    );
                  },
                  hintText: context.locale.enterSurname,
                  errorText: data.showSurnameError
                      ? context.locale.surnameEmptyError
                      : null,
                ),
                const SizedBox(height: 20),
                FormLabelText(context.locale.birthdate),
                const SizedBox(height: 8),
                FormTextField(
                  controller: birthdateController,
                  onChanged: (final String value) {
                    context.read<SignupBloc>().add(
                      BirthdateChanged(birthdate: value),
                    );
                  },
                  maxLength: 8,
                  inputFormatters: [DateInputFormatter()],
                  hintText: context.locale.birthdateExample,
                  errorText: data.showBirthdateError
                      ? context.locale.birthdateEmptyError
                      : null,
                ),
                const SizedBox(height: 20),
                FormLabelText(context.locale.email),
                const SizedBox(height: 8),
                FormTextField(
                  controller: emailController,
                  onChanged: (final String value) {
                    context.read<SignupBloc>().add(
                      EmailChanged(email: value),
                    );
                  },
                  hintText: context.locale.enterEmail,
                  errorText: data.showEmailError
                      ? context.locale.emailEmptyError
                      : null,
                ),
                const SizedBox(height: 20),
                FormLabelText(context.locale.password),
                const SizedBox(height: 8),
                FormTextField(
                  controller: passwordController,
                  onChanged: (final String value) {
                    context.read<SignupBloc>().add(
                      PasswordChanged(password: value),
                    );
                  },
                  hintText: context.locale.enterPassword,
                  obscureText: true,
                  errorText: data.showPasswordError
                      ? context.locale.passwordEmptyError
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}