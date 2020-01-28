import { User } from 'src/app/core/openapi/lingua-poly';
import { createReducer, on, Action } from '@ngrx/store';
import { AuthApiActions } from '../actions';
import { UserApiActions } from '../../user/actions';

export const statusFeatureKey = 'status';

export interface State {
	user: User | null;
}

export const initialState: State = {
	user: null,
};

export const authReducer = createReducer(
	initialState,
	on(AuthApiActions.loginSuccess, (state, { user }) => ({ ...state, user })),
	on(UserApiActions.profileSuccess, (state, { user }) => ({ ...state, user })),
	on(AuthApiActions.logoutSuccess, () => initialState),
);

export function reducer(state: State | undefined, action: Action) {
	return authReducer(state, action);
}

export const getUser = (state: State) => state.user;
