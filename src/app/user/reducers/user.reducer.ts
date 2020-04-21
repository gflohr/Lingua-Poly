import { createReducer, Action } from '@ngrx/store';

export const statusFeatureKey = 'status';

export interface State {
	uiLingua: string,
	lingua: string,
}

// FIXME! Hardcode these values in constants.
export const initialState: State = {
	uiLingua: 'en-us',
	lingua: 'fi',
};

export const userReducer = createReducer(
	initialState,
);

export function reducer(state: State | undefined, action: Action) {
	return userReducer(state, action);
}

export const getUILingua = (state: State) => state.uiLingua;
export const getLingua = (state: State) => state.lingua;
export const getPathPrefix = (state: State) => `/${state.uiLingua}/${state.lingua}`;
