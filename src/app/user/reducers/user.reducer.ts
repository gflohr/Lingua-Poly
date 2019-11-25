import { UserStateRecord, UserState } from "../states/user.state";
import { ReduxAction } from "src/app/core/actions/redux.action";
import { UserActions } from "../actions/user.actions";

export const initialState = new UserStateRecord();

export function userReducer(state: UserState = initialState, { type, payload }: ReduxAction): UserState {
	switch(type) {
		case UserActions.SET_USER:
			return state.merge({
				setUserStatus: state.setUserStatus.merge({
					error: null,
					inProgress: true
				})
			}) as UserState;
		case UserActions.SET_USER_SUCCESS:
			return state.merge({
				setUserStatus: state.setUserStatus.merge({
					error: null,
					inProgress: false,
					initDone: true
				})
			}) as UserState;
		case UserActions.SET_USER_ERROR:
			return state.merge({
				setUserStatus: state.setUserStatus.merge({
					error: payload,
					inProgress: false,
					initDone: true
				})
			}) as UserState;
		case UserActions.GET_PROFILE:
			return state.merge({
				profileStatus: state.profileStatus.merge({
					error: null,
					inProgress: true
				})
			}) as UserState;
		case UserActions.GET_PROFILE_SUCCESS:
			return state.merge({
				setUserStatus: state.profileStatus.merge({
					error: null,
					inProgress: false,
					initDone: true
				})
			}) as UserState;
		case UserActions.GET_PROFILE_ERROR:
			return state.merge({
				setUserStatus: state.profileStatus.merge({
					error: payload,
					inProgress: false,
					initDone: true
				})
			}) as UserState;
	}
}
