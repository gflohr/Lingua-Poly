import { createReducer, Action, on } from '@ngrx/store';
import { applicationConfig } from '../../app.config';
import { LinguaActions } from '../../lingua/actions';

export const statusFeatureKey = 'status';

export interface State {
	uiLingua: string,
	lingua: string,
}

// FIXME! Hardcode these values in constants.
export const initialState: State = {
	uiLingua: applicationConfig.defaultLocale,
	lingua: applicationConfig.defaultLanguage,
};

export const userReducer = createReducer(
	initialState,
	on(LinguaActions.UILinguaChanged, (state, { lingua }) => ({ ...state, uiLingua: lingua })),
);

export function reducer(state: State | undefined, action: Action) {
	return userReducer(state, action);
}

export const getUILingua = (state: State) => state.uiLingua;
export const getLingua = (state: State) => state.lingua;
export const getPathPrefix = (state: State) => `/${state.uiLingua}/${state.lingua}`;
