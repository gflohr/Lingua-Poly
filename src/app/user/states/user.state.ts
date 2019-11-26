import { StateInterface, Record } from "../../app.interfaces";

export interface UserState extends StateInterface {
	username: string;
	email: string;
	sessionTTL: number;
	lastActivity: Date;
}

export const UserStateRecord = Record({
	username: null,
	email: null,
	sessionTTL: 0,
	lastActivity: null
});
