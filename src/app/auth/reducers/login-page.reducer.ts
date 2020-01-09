import { createReducer, on, Action } from '@ngrx/store';
import { LoginPageActions, AuthApiActions } from '../actions';

export const loginPageFeatureKey = 'loginPage';

export interface State {
	error: string | null;
	pending: boolean;
}

export const initialState: State = {
	error: null,
	pending: false
};

export const loginPageReducer = createReducer(
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

export function reducer(state: State | undefined, action: Action) {
	return loginPageReducer(state, action);
}

export const getError = (state: State) => state.error;
export const getPending = (state: State) => state.pending;

