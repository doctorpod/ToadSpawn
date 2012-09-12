def fixtures(path = nil)
  fixtures_path = File.join(File.dirname(__FILE__), '..', 'fixtures')
  path.nil? ? fixtures_path : File.join(fixtures_path, path)
end

def sandbox(path = nil)
  sandbox_path = File.join(File.dirname(__FILE__), '..', 'sandbox')
  path.nil? ? sandbox_path : File.join(sandbox_path, path)
end

def reset_sandbox
  system "rm -fr #{sandbox}"
  system "mkdir #{sandbox}"
end