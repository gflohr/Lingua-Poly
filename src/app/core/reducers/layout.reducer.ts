import { createReducer, on } from "@ngrx/store";
import { LayoutActions } from "../actions";
import { AuthActions } from "src/app/auth/actions";

export const layoutFeatureKey = 'layout';

export interface State {
	showSidenav: boolean;
}

const initialState = {
	showSidenav: false
}

export const reducer = createReducer(
	initialState,
	on(LayoutActions.closeSidenav, () => ({ showSidenav: false })),
	on(LayoutActions.openSidenav, () => ({ showSidenav: true })),
	on(AuthActions.logoutConfirmation, () => ({ showSidenav: false }))
)

export const selectShowSidenav = (state: State) => state.showSidenav;
