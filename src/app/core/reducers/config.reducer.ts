import { createReducer, Action, on } from '@ngrx/store';
import { ConfigActions } from '../actions';

export const configFeatureKey = 'config';

export interface State {
	googleAuthorizationUrl: string | null;
	facebookAuthorizationUrl: string | null;
}

export const initialState:State = {
	googleAuthorizationUrl: null,
	facebookAuthorizationUrl: null
};

export const configReducer = createReducer(
	initialState,
	on(ConfigActions.configSuccess, (state, config) => {
		return {
			...state,
			googleAuthorizationUrl: config.config.googleAuthorizationUrl,
			facebookAuthorizationUrl: config.config.facebookAuthorizationUrl
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

export const getGoogleAuthorizationUrl = (state: State) => state.googleAuthorizationUrl;
export const getFacebookAuthorizationUrl = (state: State) => state.facebookAuthorizationUrl;

