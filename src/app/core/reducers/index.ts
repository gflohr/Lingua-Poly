import * as fromRoot from '../../app.reducers';
import * as fromConfig from './config.reducer';
import { createFeatureSelector, createSelector, Action, combineReducers } from '@ngrx/store';

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

export const selectHasOAuth= createSelector(
	selectCoreConfigState, config => {
		return config.hasOAuthGoogle || config.hasOAuthFacebook;
	}
);

export const selectHasOAuthFacebook = createSelector(
	selectCoreConfigState, config => config.hasOAuthFacebook
);

export const selectHasOAuthGoogle = createSelector(
	selectCoreConfigState, config => config.hasOAuthGoogle
);
