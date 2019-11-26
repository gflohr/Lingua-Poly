import { createReducer } from "@ngrx/store";

export const layoutFeatureKey = 'layout';

export interface State {
	showSidenav: boolean;
}

const initialState = {
	showSidenav: false
}

export const reducer = createReducer(
	initialState
)
