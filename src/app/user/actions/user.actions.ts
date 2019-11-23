import { Injectable } from "@angular/core";
import { UserSetDTO } from "src/app/core/models/dto";
import { ReduxAction } from "src/app/core/actions/redux.action";

@Injectable()
export class UserActions {
	static SET_USER = 'SET_USER';
	static SET_USER_SUCCESS = 'SET_USER_SUCCESS';
	static SET_USER_ERROR = 'SET_USER_ERROR';

	static GET_PROFILE = 'GET_PROFILE';
	static GET_PROFILE_SUCCESS = 'GET_PROFILE_SUCCESS';
	static GET_PROFILE_ERROR = 'GET_PROFILE_ERROR';

	setUser(data: UserSetDTO): ReduxAction {
		return { type: UserActions.SET_USER, payload: data };
	}

	setUserSuccess(userData): ReduxAction {
		return { type: UserActions.SET_USER_SUCCESS, payload: userData };
	}

	setUserError(error: Error): ReduxAction {
		return { type: UserActions.SET_USER_ERROR, payload: error };
	}

	getProfile(): ReduxAction {
		return { type: UserActions.GET_PROFILE };
	}

	getProfileSuccess(response: any): ReduxAction {
		return { type: UserActions.GET_PROFILE_SUCCESS, payload: response };
	}

	getProfileError(error: Error): ReduxAction {
		return { type: UserActions.GET_PROFILE_ERROR, payload: error };
	}
}
