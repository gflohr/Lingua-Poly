import { createReducer, Action, on } from '@ngrx/store';
import { ConfigActions } from '../actions';

export const configFeatureKey = 'config';

export interface State {
	hasOAuthGoogle: boolean;
	hasOAuthFacebook: boolean;
}

export const initialState:State = {
	hasOAuthGoogle: false,
	hasOAuthFacebook: false,
};

export const configReducer = createReducer(
	initialState,
	on(ConfigActions.configSuccess, (state, config) => {
		return {
			...state,
			hasOAuthGoogle: config.config.hasOAuthGoogle,
			hasOAuthFacebook: config.config.hasOAuthFacebook,
		};
	}),
	// At a later point we may choose to refresh the configuration.  In case
	// of failure it is therefore better to just continue with the current
	// configuration.
	on(ConfigActions.configFailure, state => state)
);

export function reducer(state: State | undefined, action: Action) {
	return configReducer(state, action);
}

export const getHasOAuthGoogle = (state: State) => state.hasOAuthGoogle;
export const getHasOAuthFacebook = (state: State) => state.hasOAuthFacebook;

