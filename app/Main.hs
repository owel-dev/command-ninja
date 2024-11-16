{-# LANGUAGE ScopedTypeVariables #-}

import System.Environment (getEnv)
import System.IO (hFlush, stdout, hPutStrLn, stderr)
import System.Process (readProcessWithExitCode)
import Control.Exception (catch, IOException)
import Control.Monad (when, forever)
import Data.Char (isSpace)

main :: IO ()
main = forever $ do
    putStr "Enter a command (type 'exit' to quit): "
    hFlush stdout

    command <- getLine
    let trimmedCommand = trim command

    if trimmedCommand == "exit" || trimmedCommand == "quit"
        then do
            putStrLn "Exiting the program."
            return ()
        else do
            shell <- catch (getEnv "SHELL") (\(_ :: IOException) -> return "/bin/sh")
            (exitCode, out, err) <- readProcessWithExitCode shell ["-c", trimmedCommand] ""

            when (not $ null out) $ do
                putStrLn "Command output:"
                putStr out

            when (not $ null err) $ do
                hPutStrLn stderr "Error message:"
                hPutStrLn stderr err
                
trim :: String -> String
trim = f . f
  where f = reverse . dropWhile isSpace