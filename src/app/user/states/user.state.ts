import { StateInterface, Record } from "../../app.interfaces";

export interface UserState extends StateInterface {
	profile: any;
}

export const userStateRecord = Record({
	profile: null
});
