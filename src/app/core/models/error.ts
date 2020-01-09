import { Model } from '../model';

export class StoreError extends Model<StoreError> {
	created: string;
	error: Error;

	constructor(error: Error) {
		super();
		this.created = new Date().toISOString();
		this.error = error;
	}

	static of(error: Error) {
		return new StoreError(error);
	}

	getError(): Error {
		return this.error;
	}

	getApiData(properties?: any): { [p: string]: any } {
		return {};
	}
}
