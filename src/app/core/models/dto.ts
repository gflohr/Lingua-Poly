import { UserBaseModel } from './user';

export interface ErrorHandlerDataDTO {
	message: string;
	params: { [key: string]: any };
}

export interface UserSetDTO {
	user: UserBaseModel;
	data: { [key: string]: any };
}
