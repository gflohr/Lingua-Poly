import { StoreError } from "./core/models/error";

export interface StateInterface {
	get(name: string): any;
	merge(obj: Object): any;
}

export interface ActionStatus extends StateInterface {
	initDone?: boolean;
	initProgress: boolean;
	error: StoreError | Error;
}

export class ReducerState implements StateInterface {
	constructor(private _values: { [key: string]: any }) {
		for (const key in _values) {
			if (_values.hasOwnProperty(key)) {
				this[key] = _values[key];
			}
		}
	}

	get(name: string): any {
		if (typeof this[name] !== 'undefined') {
			return this[name];
		}
	}

	merge(obj): ReducerState {
		const old = {};
		for (const key in this._values) {
			if (this._values.hasOwnProperty(key)) {
				old[key] = this[key];
			}
		}

		return new ReducerState({
			...old,
			...this.setError(obj)
		});
	}
}
