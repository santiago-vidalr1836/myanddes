package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.io.FileUtils;
import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import pe.compendio.myandess.onboarding.controller.dto.FileDTO;
import pe.compendio.myandess.onboarding.entity.File;
import pe.compendio.myandess.onboarding.service.FileService;
import pe.compendio.myandess.onboarding.service.MediaLoaderService;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

@RestController
@RequestMapping(path = "/files")
public class FileController {
  @Autowired
  FileService fileService;
  @Autowired
  MediaLoaderService mediaLoaderService;

  @Operation(summary = "Agregar un nuevo archivo")
  @PostMapping
  public FileDTO addFile(@RequestParam(value = "file")MultipartFile multipartFile){
    return FileDTO.builder()
                  .url(fileService.save(multipartFile))
                  .build();
  }

  @Operation(summary = "Obtener el archivo por id")
  @GetMapping(value = "/public/{fileId}/filename/{filename}")
  public ResponseEntity<byte[]>  file(@PathVariable Long fileId) throws IOException {
    var entity = fileService.getFile(fileId);
    java.io.File file=new java.io.File(entity.getPath());
    InputStream inputStream= new ByteArrayInputStream(FileUtils.readFileToByteArray(file));

    Tika tika = new Tika();
    String contentType = tika.detect(inputStream,entity.getFilename());

    return ResponseEntity.ok()
      .contentType(MediaType.parseMediaType(contentType))
      .body(IOUtils.toByteArray(inputStream));
  }

  @Operation(summary = "Obtener stream de un archivo de tipo video")
  //https://www.codeproject.com/Articles/5341970/Streaming-Media-Files-in-Spring-Boot-Web-Applicati
  @GetMapping("/public/{fileId}/video/{fileName}")
  public ResponseEntity<StreamingResponseBody> video(@PathVariable Long fileId,
                                                     @PathVariable String fileName,
                                                     @RequestHeader(value = "Range", required = false) String rangeHeader) throws IOException {
    File file = fileService.getFile(fileId);
    try{
      String filePathString = file.getPath();
      return mediaLoaderService.loadPartialMediaFile(filePathString, rangeHeader);
    }catch (FileNotFoundException e){
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }catch (IOException e){
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}

