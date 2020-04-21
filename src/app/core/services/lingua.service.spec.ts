import { TestBed } from '@angular/core/testing';

import { LinguaService } from './lingua.service';

describe('LinguaService', () => {
  let service: LinguaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LinguaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
