import { TestBed, inject } from '@angular/core/testing';

import { ApiErrorHandlerService } from './api-error-handler.service';

describe('ApiErrorHandlerService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ApiErrorHandlerService]
    });
  });

  it('should be created', inject([ApiErrorHandlerService], (service: ApiErrorHandlerService) => {
    expect(service).toBeTruthy();
  }));
});
