import { createReducer, on } from "@ngrx/store";
import { LoginPageActions, AuthApiActions } from "../actions";

export const loginPageFeatureKey = 'loginPage';

export interface State {
	error: string | null,
	pending: boolean
};

export const initialState: State = {
	error: null,
	pending: false
};

export const reducer = createReducer(
	initialState,
	on(LoginPageActions.login, state => ({
		...state,
		error: null,
		pending: true,
	})),

	on(AuthApiActions.loginSuccess, state => ({
		...state,
		error: null,
		pending: false,
	})),

	on(AuthApiActions.loginFailure, (state, { error }) => ({
		...state,
		error,
		pending: false,
	}))
);
