import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/network/failure.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.firebaseAuthService});

  final FirebaseAuthService firebaseAuthService;

  @override
  Future<void> onNavigation(
    final NavigationResolver resolver,
    final StackRouter router,
  ) async {
    final Either<Failure, bool> isSignedInResult = await firebaseAuthService
        .isSignedIn();

    await isSignedInResult.fold(
      (final Failure failure) async {
        await router.replace(
          OnboardingRoute(
            onLoggedIn: ({final bool isFromSignup = false}) async {
              if (isFromSignup) {
                await router.replaceAll(<PageRouteInfo<Object?>>[
                  const CreateProfileRoute(),
                ]);
              } else {
                resolver.next();
              }
            },
          ),
        );
      },
      (final bool isSignedIn) async {
        if (isSignedIn) {
          resolver.next();
        } else {
          await router.replace(
            OnboardingRoute(
              onLoggedIn: ({final bool isFromSignup = false}) async {
                if (isFromSignup) {
                  await router.replaceAll(<PageRouteInfo<Object?>>[
                    const CreateProfileRoute(),
                  ]);
                } else {
                  await router.replace(
                    const DashboardRouter(children: [HomeRoute()]),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
