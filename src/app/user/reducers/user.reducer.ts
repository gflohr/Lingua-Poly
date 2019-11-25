import { UserStateRecord, UserState } from "../states/user.state";
import { ReduxAction } from "src/app/core/actions/redux.action";
import { UserActions } from "../actions/user.actions";

export const initialState = new UserStateRecord();

export function userReducer(state: UserState = initialState, { type, payload }: ReduxAction): UserState {
	switch(type) {
		//case UserActions.GET_PROFILE_ERROR:
		//	return state.merge({
		//		setUserStatus: state.profileStatus.merge({
		//			error: payload,
		//			inProgress: false,
		//			initDone: true
		//		})
		//	}) as UserState;
	}

	return state;
}
