export abstract class Model<T> {
	static getValue(value: any, defaultValue: any): any {
		if (typeof value !== 'undefined') {
		return value;
		}

		return defaultValue;
	}

	abstract getApiData(properties?: any): { [key: string]: any };

	clone(): T {
		return Object.assign(Object.create(Object.getPrototypeOf(this)), this) as T;
	}

	copy(resource: T): T {
		return Object.assign(this, resource) as T;
	}

	getValue(value: any, defaultValue: any): any {
		return Model.getValue(value, defaultValue);
	}
}
