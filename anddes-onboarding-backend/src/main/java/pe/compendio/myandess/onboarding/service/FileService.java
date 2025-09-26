package pe.compendio.myandess.onboarding.service;

import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import pe.compendio.myandess.onboarding.repository.FileRepository;
import pe.compendio.myandess.onboarding.util.RandomUtil;

import java.io.*;
import java.util.Date;

@Service
public class FileService {
  @Value("${onboarding.files.folder}")
  private String folder;
  @Value("${onboarding.files.url.file}")
  private String urlFile;
  @Value("${onboarding.files.url.video}")
  private String urlVideo;
  @Autowired
  FileRepository fileRepository;

  public String save(MultipartFile multipartFile) {
    String randomFileName=RandomUtil.text(4) + new Date().getTime()+multipartFile.getOriginalFilename();

    File file = new File(folder+"/"+randomFileName);

    try (OutputStream os = new FileOutputStream(file)) {
      os.write(multipartFile.getBytes());
      var entity=new pe.compendio.myandess.onboarding.entity.File();
      entity.setFilename(multipartFile.getOriginalFilename());
      entity.setPath(file.getAbsolutePath());
      entity=fileRepository.save(entity);

      //return  urlFile.replace("{fileId}",String.valueOf(entity.getId())).replace("{filename}",entity.getFilename());
      try(InputStream inputStream = new FileInputStream(file)){
        Tika tika = new Tika();
        String contentType = tika.detect(inputStream,entity.getFilename());
        if(contentType.contains("video")){
          return urlVideo.replace("{fileId}",String.valueOf(entity.getId())).replace("{name}",entity.getFilename());
        }else{
          return  urlFile.replace("{fileId}",String.valueOf(entity.getId())).replace("{filename}",entity.getFilename());
        }
      }
    } catch (IOException exception) {
      exception.printStackTrace();
    }
    return null;
  }
  public pe.compendio.myandess.onboarding.entity.File getFile(Long idFile){
    return fileRepository.findById(idFile).orElse(null);
  }
}
