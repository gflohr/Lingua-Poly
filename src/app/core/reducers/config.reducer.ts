import { createReducer, Action, on } from '@ngrx/store';
import { ConfigActions } from '../actions';

export const configFeatureKey = 'config';

export interface State {
	googleClientId: string | null;
	facebookClientId: string | null;
}

export const initialState:State = {
	googleClientId: null,
	facebookClientId: null
};

export const configReducer = createReducer(
	initialState,
	on(ConfigActions.configSuccess, (state, config) => {
		return {
			...state,
			googleClientId: config.config.googleClientId,
			facebookClientId: config.config.facebookClientId
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

export const getGoogleClientId = (state: State) => state.googleClientId;
export const getFacebookClientId = (state: State) => state.facebookClientId;

