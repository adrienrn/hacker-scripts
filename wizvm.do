#!/usr/bin/python

import argparse
import subprocess
import re
from os.path import expanduser

def util_get_args():
  parser = argparse.ArgumentParser()
  parser.add_argument('command', nargs='?', default='help')

  return parser.parse_args()

def util_get_status():
  report = {
    'sshfs_mounted': False,
    'sshfs_buggy'  : False,
    'wizvm_running': False,
  }

  process = subprocess.Popen(['mount'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=workingPath)
  (out, err) = process.communicate()
  for line in out.split('\n'):
    if line.find('vagrant@wiz.local') >= 0:
      report['sshfs_mounted'] = True

  process = subprocess.Popen(['ls', 'redcurrents'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=workingPath)
  (out, err) = process.communicate()
  if 0 != process.returncode:
    report['sshfs_buggy'] = True      
      
  process = subprocess.Popen(['vagrant', 'status', '--machine-readable'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=workingPath)
  (out, err) = process.communicate()
  for line in out.split('\n'):
   if line.find(',state,') >= 0:
     match = re.search(',state,(.+)$', line)
     if match:
      report['wizvm_running'] = match.group(1) == 'running'

  return report

#
def do_help():
  print 'help!'

def do_mount():
  status = util_get_status()

  if status['sshfs_buggy'] == True:
    print "sshfs has crashed. It might still appear connected but is not."

  if status['sshfs_mounted'] == True:
    print "Already mounted!"
    return

  process = subprocess.Popen(['sshfs', 'vagrant@wiz.local:redcurrents', './redcurrents'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=workingPath)
  (out, err) = process.communicate()
  if process.returncode != 0:
    print 'An error occured: "' + err.rstrip() + '"'

def do_umount():
  (out, err) = subprocess.Popen(['umount', workingPath + '/redcurrents'], stdout=subprocess.PIPE, cwd=workingPath).communicate()
  print out
  print err

def do_up():
  (out, err) = subprocess.Popen(['vagrant', 'up'], stdout=subprocess.PIPE, cwd=workingPath).communicate()
  print out

def do_status():
  print util_get_status()

# Some globals
args        = util_get_args()
workingPath = expanduser('~') + '/Desktop/Wiztopic/dev/redcurrents'

# Dictionary of commands
commands = {
  'help'  : do_help,
  'mount' : do_mount,
  'status': do_status,
  'umount': do_umount,
  'up':     do_up,
  #
}

try:
  commands[args.command]()
except KeyError as e:
  do_help()
