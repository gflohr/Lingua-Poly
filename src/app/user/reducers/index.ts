export const userFeatureKey = 'user';

import * as fromRoot from '../../app.reducers';
import * as fromUser from './user.reducer';
import { combineReducers, Action, createFeatureSelector, createSelector } from '@ngrx/store';

export interface UserState {
	[fromUser.statusFeatureKey]: fromUser.State;
}

export interface State extends fromRoot.State {
	[userFeatureKey]: UserState;
}

export function userReducers(state: UserState | undefined, action: Action) {
	return combineReducers({
		[fromUser.statusFeatureKey]: fromUser.reducer,
	})(state, action);
}

export const selectUserState = createFeatureSelector<State, UserState>(
	userFeatureKey
);

export const selectUserStatusState = createSelector(
	selectUserState,
	(state: UserState) => state.status
);

export const selectUILingua = createSelector(
	selectUserStatusState,
	fromUser.getUILingua
);

export const selectLingua = createSelector(
	selectUserStatusState,
	fromUser.getLingua
);

export const selectPathPrefix = createSelector(
	selectUserStatusState,
	fromUser.getPathPrefix
);
