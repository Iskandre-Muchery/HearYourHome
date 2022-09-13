import { Component , OnInit } from '@angular/core';


@Component({
  selector: 'app-form',
  templateUrl: './formOnlyJs.html',
  styleUrls: ['./formOnlyJs.scss']
})

export class FormComponent implements OnInit {
  
  floating_btn = document.querySelector('floating-btn');
  close_btn = document.querySelector('close-btn');
  social_panel_container = document.querySelector('social-panel-container');
  floating_btn_check = document.getElementById('floating-btn');
  close_btn_check = document.getElementById('close-btn');

  

  showSocialPanel() : void {
    if (this.floating_btn_check) {
      // @ts-ignore: Object is possibly 'null'.
      this.floating_btn.addEventListener('click', () => {
        // @ts-ignore: Object is possibly 'null'.
        this.social_panel_container.classList.toggle('visible')
      });
    }
    if (this.close_btn_check) {
      // @ts-ignore: Object is possibly 'null'.
      this.close_btn.addEventListener('click', () => {
        // @ts-ignore: Object is possibly 'null'.
        this.social_panel_container.classList.remove('visible')
      });
    }

  }
  ngOnInit(): void {
  }
}

