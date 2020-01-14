import { TestBed } from '@angular/core/testing';

import { OAuth2Service } from './oauth2.service';

describe('OAuth2Service', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: OAuth2Service = TestBed.get(OAuth2Service);
    expect(service).toBeTruthy();
  });
});
