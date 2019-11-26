import { User } from "src/app/core/openapi/lingua-poly";
import { createReducer, on } from "@ngrx/store";
import { AuthApiActions, AuthActions } from "../actions";

export const statusFeatureKey = 'status';

export interface State {
	user: User | null;
}

export const initialState: State = {
	user: null
};

export const reducer = createReducer(
	initialState,
	on(AuthApiActions.loginSuccess, (state, { user }) => ({ ...state, user })),
	on(AuthActions.logout, () => initialState)
);

export const getUser = (state: State) => state.user;
