use std::env;
use std::process::Command;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args[1] == "commit" {
        let output_git_diff = Command::new("git")
        .arg("diff")
        .output()
        .expect("failed to execute process for git(diff)");

        // Fine Tuning
        let query = format!(
            "Here is the output from `git diff`:\n\n{}\n\nYou are a professional with advanced Git knowledge. Based on this diff, generate a clear and concise Git commit message.",
            String::from_utf8_lossy(&output_git_diff.stdout)
        );
       
        let output_ollama = Command::new("ollama")
        .arg("run")
        .arg("phi3:mini")
        .arg(&query)
        .output()
        .expect("failed to execute process for ollama");

        let commit_message = String::from_utf8_lossy(&output_ollama.stdout);
        let output_git_commit = Command::new("git")
        .arg("commit")
        .arg("-m")
        .arg(&*commit_message)
        .output()
        .expect("failed to execute process for git(commit)");

        println!("{}", String::from_utf8_lossy(&output_git_commit.stdout));
    }
}

// Command sample with harcoded query: ollama run phi3:mini "Explain quantum computing like I’m five"
