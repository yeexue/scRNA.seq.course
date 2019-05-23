
Channel
    .fromPath("$baseDir/course_files", type: 'dir')
    .into { ch_course_files1; ch_course_files2 }

Channel
    .fromPath('s3://scrnaseq-course/data', checkIfExists: false)
    .into { ch_data1; ch_data2 }

process html {
  //publishDir 's3://scrnaseq-course', mode: 'copy' , overwrite: true
  input: 
    file fs from ch_course_files1
    file dat from ch_data1
  output:
    file website
  script:
  """
  cp -r $fs/* .
  Rscript -e "bookdown::render_book('index.html', 'bookdown::gitbook')"
  """
}

process latex {
  input: 
    file fs from ch_course_files2
    file dat from ch_data2
  script:
  """
  cp -r $fs/* .
  Rscript -e "bookdown::render_book('index.html', 'bookdown::pdf_book')"
  """
}
