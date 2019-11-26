import { UserStateRecord, UserState } from "../states/user.state";

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
