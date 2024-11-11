package egovframework.mango.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

public class ArchiveUtils2 {

	private FileInputStream fInput = null;

	private FileOutputStream fOutput = null;

	private ZipInputStream zInput = null;

	@SuppressWarnings("unused")
	private ZipOutputStream zOutput = null;

	private ZipEntry zEntry = null;

	public ArchiveUtils2() {
		// TODO Auto-generated constructor stub
	}

	private static final int BUFFER_SIZE = 1024 * 10;

	public void unzip(File zipFile) throws IOException {
		unzip(zipFile.getAbsolutePath());
	}

	public void unzip(String zipPath) throws IOException {
		String outDir = zipPath.substring(0, zipPath.lastIndexOf("."));
		unzip(zipPath, outDir);
	}

	public void unzip(File zipFile, String outDir) throws IOException {
		unzip(zipFile.getAbsolutePath(), outDir);
	}

	public void unzip(String zipPath, String outDir) throws IOException {

		File zipFile = new File(zipPath);

		try {
			if (zipFile.exists() && zipFile.isFile()) {

				fInput = new FileInputStream(zipPath);
				fOutput = null;
				zInput = new ZipInputStream(fInput);

				zEntry = null;

				// 압축을 해제할 디렉토리 생성
				File outDirFile = new File(outDir);
				if (!outDirFile.exists()) {
					outDirFile.setExecutable(false);
					outDirFile.setReadable(true);
					outDirFile.setWritable(false, true);
					outDirFile.mkdir();
				}

				byte[] byteBuffer = new byte[BUFFER_SIZE];

				while ((zEntry = zInput.getNextEntry()) != null) {
					String fName = zEntry.getName();
					File zInFile = new File(fName);

					if (zEntry.isDirectory()) {
						File makeDir = new File(outDir + File.separator + zInFile);
						makeDir.setExecutable(false);
						makeDir.setReadable(true);
						makeDir.setWritable(false, true);
						makeDir.mkdirs();
					} else {

						File outFile = new File(outDir + File.separator + zInFile);
						if (!outFile.getParentFile().exists()) {
							outFile.getParentFile().setExecutable(false);
							outFile.getParentFile().setReadable(true);
							outFile.getParentFile().setWritable(false, true);
							outFile.getParentFile().mkdirs();
						}
						fOutput = new FileOutputStream(outFile);

						for (int cnt = 0; (cnt = zInput.read(byteBuffer)) != -1;) {
							fOutput.write(byteBuffer, 0, cnt);
						}
						fOutput.close();
					}
				}

			}
		} finally {
			if (fInput != null) {
				try {
					fInput.close();
				} catch (IOException ioe) {
					zipPath = zipFile.getAbsolutePath();
				}
			}

			if (zInput != null) {
				try {
					zInput.close();
				} catch (IOException ioe) {
					zipPath = zipFile.getAbsolutePath();
				}
			}
		}
	}

	public void unzipChgName(File zipFile, String outDir) throws IOException {
		unzipChgName(zipFile.getAbsolutePath(), outDir);
	}

	public void unzipChgName(String zipPath, String outDir) throws IOException {

		File zipFile = new File(zipPath);
		String newName = zipFile.getName().substring(0, zipFile.getName().lastIndexOf("."));
		try {
			if (zipFile.exists() && zipFile.isFile()) {

				fInput = new FileInputStream(zipPath);
				fOutput = null;
				zInput = new ZipInputStream(fInput);

				zEntry = null;

				// 압축을 해제할 디렉토리 생성
				File outDirFile = new File(outDir);
				if (!outDirFile.exists()) {
					outDirFile.setExecutable(false);
					outDirFile.setReadable(true);
					outDirFile.setWritable(false, true);
					outDirFile.mkdir();
				}

				byte[] byteBuffer = new byte[BUFFER_SIZE];

				while ((zEntry = zInput.getNextEntry()) != null) {
					String fName = zEntry.getName();
					if (fName.endsWith("/")) {
						continue;
					}
					fName = newName + fName.substring(fName.lastIndexOf("."));
					File zInFile = new File(fName);

					if (zEntry.isDirectory()) {
						File makeDir = new File(outDir + File.separator + zInFile);
						makeDir.setExecutable(false);
						makeDir.setReadable(true);
						makeDir.setWritable(false, true);
						makeDir.mkdirs();
					} else {

						fName = newName + fName.substring(fName.lastIndexOf("."));
						zInFile = new File(fName);

						File outFile = new File(outDir + File.separator + zInFile);
						if (!outFile.getParentFile().exists()) {
							outFile.getParentFile().setExecutable(false);
							outFile.getParentFile().setReadable(true);
							outFile.getParentFile().setWritable(false, true);
							outFile.getParentFile().mkdirs();
						}

						try {
							fOutput = new FileOutputStream(outFile);

							for (int cnt = 0; (cnt = zInput.read(byteBuffer)) != -1;) {
								fOutput.write(byteBuffer, 0, cnt);
							}
						} finally {
							if (fOutput != null) {
								try {
									fOutput.close();
								} catch (IOException ioe) {
									zipPath = zipFile.getAbsolutePath();
								}
							}
						}
					}
				}
			}
		} finally {
			if (fInput != null) {
				try {
					fInput.close();
				} catch (IOException ioe) {
					zipPath = zipFile.getAbsolutePath();
				}
			}

			if (zInput != null) {
				try {
					zInput.close();
				} catch (IOException ioe) {
					zipPath = zipFile.getAbsolutePath();
				}
			}
		}
	}

	public void zip(String srcPath, String outZip) throws NullPointerException, Exception {

		compress(srcPath, outZip);

	}

	public boolean compress(String path, String outputPath) throws FileNotFoundException, NullPointerException, Exception {
		// 파일 압축 성공 여부
		boolean isChk = false;

		File file = new File(path);

		// 압축 경로 체크
		if (!file.exists()) {
			
			throw new FileNotFoundException("Not File!");
		}

		// 출력 스트림
		FileOutputStream fos = null;
		// 압축 스트림
		ZipOutputStream zos = null;

		try {
			fos = new FileOutputStream(new File(outputPath));
			zos = new ZipOutputStream(fos);

			// 디렉토리 검색를 통한 하위 파일과 폴더 검색
			searchDirectory(file, file.getPath(), zos);

			// 압축 성공.
			isChk = true;
		} catch (NullPointerException e) {
			throw e;
		} catch (Exception e) {
			throw e;
		} finally {
			if (zos != null) {
				try {
					zos.close();
				} catch (IOException ioe) {
					path = file.getAbsolutePath();
				}
			}

			if (fos != null) {
				try {
					fos.close();
				} catch (IOException ioe) {
					path = file.getAbsolutePath();
				}
			}
		}
		return isChk;
	}

	/**
	 * @description 디렉토리 탐색
	 * @param file 현재 파일
	 * @param root 루트 경로
	 * @param zos  압축 스트림
	 */
	private void searchDirectory(File file, String root, ZipOutputStream zos) throws NullPointerException, Exception {
		// 지정된 파일이 디렉토리인지 파일인지 검색
		if (file.isDirectory()) {
			File[] files = file.listFiles();
			for (File f : files) {
				//System.out.println("file = > " + f);
				searchDirectory(f, root, zos);
			}
		} else {
			// 파일일 경우 압축을 한다.
			try {
				compressZip(file, root, zos);
			} catch (NullPointerException e) {
				root = file.getAbsolutePath();
			} catch (Throwable e) {
				root = file.getAbsolutePath();
			}
		}
	}

	/**
	 * @description압축 메소드
	 * @param file
	 * @param root
	 * @param zos
	 * @throws Throwable
	 */
	private void compressZip(File file, String root, ZipOutputStream zos) throws NullPointerException, Exception {
		FileInputStream fis = null;
		try {
			String zipName = file.getName();
			// 파일을 읽어드림
			fis = new FileInputStream(file);
			// Zip엔트리 생성(한글 깨짐 버그)
			ZipEntry zipentry = new ZipEntry(zipName);
			// 스트림에 밀어넣기(자동 오픈)
			zos.putNextEntry(zipentry);
			// int length = (int) file.length();
			// int bufferSize = BUFFER_SIZE;
			byte[] buffer = new byte[BUFFER_SIZE];
			int len = -1;
			while ((len = fis.read(buffer)) > 0) {
				zos.write(buffer, 0, len);
			}

			// 스트림 읽어드리기
			// fis.read(buffer, 0, length);
			// 스트림 작성
			// zos.write(buffer, 0, length);
			// 스트림 닫기
			zos.closeEntry();

		} catch (NullPointerException e) {
			throw e;
		} catch (Throwable e) {
			throw e;
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (IOException ioe) {
					root = file.getAbsolutePath();
				}
			}
		}
	}

}
