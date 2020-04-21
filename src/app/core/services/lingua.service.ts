import { Injectable, OnInit } from '@angular/core';

const KEY = 'lingua-poly-lingua';

@Injectable({
	providedIn: 'root'
})
export class LinguaService {
	supported = [
		'en-us',
		'de'
	];

	defaultLingua(): string {
		return 'en-us';
	}

	supportedLingua(lingua: string): boolean {
		if(this.supported.includes(lingua))
			return true;
		else
			return false;
	}

	getLingua(): string {
		if (this.checkLocalStorage()) {
			return localStorage.getItem(KEY);
		} else {
			return null;
		}
	}

	setLingua(lingua: string) {
		if (this.checkLocalStorage()) {
			localStorage.setItem(KEY, lingua);
		}
	}

	checkLocalStorage() {
		let storage;
		try {
			storage = window['localStorage'];
			let x = '__storage_test__';
			storage.setItem(x, x);
			storage.removeItem(x);
			return true;
		}
		catch(e) {
			return e instanceof DOMException && (
				// everything except Firefox
				e.code === 22 ||
				// Firefox
				e.code === 1014 ||
				// test name field too, because code might not be present
				// everything except Firefox
				e.name === 'QuotaExceededError' ||
				// Firefox
				e.name === 'NS_ERROR_DOM_QUOTA_REACHED') &&
				// acknowledge QuotaExceededError only if there's something already stored
				(storage && storage.length !== 0);
		}
	}
}
