import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/moods.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/home/domain/usecase/home_local_usecase.dart';


part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc(this._usecase) : super(const HomeInitial()) {
    on<LoadHomeData>((final LoadHomeData event, final Emitter<HomeState> emit) async {
      emit(const HomeLoading());

      final String? moodLabel = _usecase.getMood();
      final Mood? mood = Mood.fromString(moodLabel);

      final UserEntity? user = _usecase.getSavedUserCredentials();
      final String name = user?.name ?? 'User';

      emit(HomeLoaded(name: name, mood: mood));
    });
  }
  final HomeLocalUsecase _usecase;
}
