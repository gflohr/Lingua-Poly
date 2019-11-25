import { StateInterface, Record } from "../../app.interfaces";

export interface UserState extends StateInterface {
	username: string;
	email: string;
	validity: number;
	loggedIn: Date;
}

export const UserStateRecord = Record({
	username: null,
	email: null,
	validity: 0,
	loggedIn: null
});
