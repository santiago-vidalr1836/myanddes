import { Component, EventEmitter, Input, Output } from '@angular/core';
import { EditorChangeContent, EditorChangeSelection, QuillEditorComponent } from 'ngx-quill';
import { FileService } from '../../service/file.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-html-editor',
  standalone: true,
  imports: [QuillEditorComponent,FormsModule],
  templateUrl: './html-editor.component.html',
  styleUrl: './html-editor.component.scss'
})
export class HtmlEditorComponent {
  @Input() content:string
  @Output() contentUpdated = new EventEmitter<string>();
  quillEditorRef: any;
  constructor(private fileService:FileService){}
  onContentChanged(event: EditorChangeContent | any) {
    this.contentUpdated.emit(event.html)
  }
  getEditorInstance(editorInstance: any) {
    this.quillEditorRef = editorInstance;
    const toolbar = this.quillEditorRef.getModule('toolbar');
    // toolbar.addHandler('image', this.imageHandler);
    toolbar.addHandler('image', this.uploadImageHandler);
  }
  uploadImageHandler = () => {
    const input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');
    input.click();
    input.onchange = async () => {
      const file = input.files?.length ? input.files[0] : null;
      const range = this.quillEditorRef.getSelection();
      // const id = await 
      this.fileService.upload(file).subscribe((res : any) => {
          this.quillEditorRef.insertEmbed(range.index, 'image', res.url);
      });
    }
  }
  
}
