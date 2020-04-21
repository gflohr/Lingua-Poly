import { TestBed } from '@angular/core/testing';

import { UILinguaService } from './ui-lingua.service';

describe('UILinguaService', () => {
	let service: UILinguaService;

	beforeEach(() => {
		TestBed.configureTestingModule({});
		service = TestBed.inject(UILinguaService);
	});

	it('should be created', () => {
		expect(service).toBeTruthy();
	});
});
