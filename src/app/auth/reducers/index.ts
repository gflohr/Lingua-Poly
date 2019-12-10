export const authFeatureKey = 'auth';

import * as fromRoot from '../../app.reducers';
import * as fromAuth from './auth.reducer';
import * as fromLoginPage from './login-page.reducer';
import { combineReducers, Action, createFeatureSelector, createSelector } from '@ngrx/store';

export interface AuthState {
	[fromAuth.statusFeatureKey]: fromAuth.State,
	[fromLoginPage.loginPageFeatureKey]: fromLoginPage.State;
}

export interface State extends fromRoot.State {
	[authFeatureKey]: AuthState;
}

export function reducers(state: AuthState | undefined, action: Action) {
	return combineReducers({
		[fromAuth.statusFeatureKey]: fromAuth.reducer,
		[fromLoginPage.loginPageFeatureKey]: fromLoginPage.reducer
	})(state, action);
}

export const selectAuthState = createFeatureSelector<State, AuthState>(
	authFeatureKey
);

export const selectAuthStatusState = createSelector(
	selectAuthState,
	(state: AuthState) => state.status
);

export const selectUser = createSelector(
	selectAuthStatusState,
	fromAuth.getUser
);

export const selectLoggedIn = createSelector(selectUser, user => !!user);

export const selectLoginPageState = createSelector(
	selectAuthState,
	(state: AuthState) => state.loginPage
);

export const selectLoginPageError = createSelector(
	selectLoginPageState,
	fromLoginPage.getError
);

export const selectLoginPagePending = createSelector(
	selectLoginPageState,
	fromLoginPage.getPending
);

export const selectDisplayName = createSelector(
	selectUser, user => {
		if (user) {
			if (typeof user.username !== undefined) {
				return user.username;
			} else if (typeof user.email !== undefined) {
				return user.email;
			} else {
				return null;
			}
		}

		return null;
	}
)

export const selectUsername = createSelector(
	selectUser, user => {
		return user ? user.username : null;
	}
)
