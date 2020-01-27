import { Component, OnInit } from '@angular/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';
import { ErrorCodesService } from '../../../core/services/error-codes.service';

@Component({
  selector: 'app-error-message',
  templateUrl: './error-message.component.html',
  styleUrls: ['./error-message.component.sass']
})
export class ErrorMessageComponent implements OnInit {

	title = 'Hello, world!';
	message = 'It\'s a sad and beautiful world!';

	constructor(
		public activeModal: NgbActiveModal,
		public errorCodesService: ErrorCodesService,
	) {}

	ngOnInit() {
		this.errorCodesService.currentCode.subscribe((code) => {
			const message = this.errorCodesService.message(code);
			this.title = message.title;
			this.message = message.text;
		});
	}

}
