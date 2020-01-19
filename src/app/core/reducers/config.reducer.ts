import { createReducer, Action } from '@ngrx/store';

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
	initialState
);

export function reducer(state: State | undefined, action: Action) {
	return configReducer(state, action);
}

export const getGoogleClientId = (state: State) => state.googleClientId;
export const getFacebookClientId = (state: State) => state.facebookClientId;

