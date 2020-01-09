import { Model } from '../model';
import { User } from '../openapi/lingua-poly';

export abstract class UserBaseModel extends Model<UserBaseModel> implements User {
	email?: string;
	username?: string;
	/**
	 * Number of seconds before session expires.
	 */
	expires?: number;
}
