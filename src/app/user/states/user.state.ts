import { StateInterface, Record, ActionStatus, NewActionStatus } from "../../app.interfaces";

export interface UserState extends StateInterface {
	profile: any;
	preferences: Map<string, any>;
	profileStatus: ActionStatus;
	setUserStatus: ActionStatus;
}

export const userStateRecord = Record({
	profile: null,
	preferences: null,
	profileStatus: NewActionStatus(),
	setUserStatus: NewActionStatus()
});
