import * as fromRoot from '../../app.reducers';
import * as fromConfig from './config.reducer';
import { createFeatureSelector, createSelector, Action, combineReducers } from '@ngrx/store';
import { config } from 'rxjs';

export const coreFeatureKey = 'core';

export interface CoreState {
	[fromConfig.configFeatureKey]: fromConfig.State
}

export interface State extends fromRoot.State {
	[coreFeatureKey]: CoreState,
}

export function coreReducers(state: CoreState | undefined, action: Action) {
	return combineReducers({
		[fromConfig.configFeatureKey]: fromConfig.reducer
	})(state, action)
}

export const selectCoreState = createFeatureSelector<State, CoreState>(
	coreFeatureKey
);

export const selectCoreConfigState = createSelector(
	selectCoreState,
	(state: CoreState) => state[fromConfig.configFeatureKey]
);

export const selectHasOauthLogin = createSelector(
	selectCoreConfigState, config => {
		if (config.googleClientId != null || config.googleClientId != null) {
			return true;
		} else {
			return false;
		}
	}
);

export const selectFacebookClientId = createSelector(
	selectCoreConfigState, config => config.facebookClientId
);

export const selectGoogleClientId = createSelector(
	selectCoreConfigState, config => config.googleClientId
);
