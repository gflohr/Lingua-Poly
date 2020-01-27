import { TestBed } from '@angular/core/testing';

import { ErrorCodesService } from './error-codes.service';

describe('ErrorCodesService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ErrorCodesService = TestBed.get(ErrorCodesService);
    expect(service).toBeTruthy();
  });
});
