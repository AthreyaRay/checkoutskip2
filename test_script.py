import argparse

def main(args):
    if args.experiment:
        print("Running in experimental mode.")
    else:
        print("Running in normal mode.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--experiment", action='store_true', help="Enable experimental mode")
    args = parser.parse_args()
    main(args)
